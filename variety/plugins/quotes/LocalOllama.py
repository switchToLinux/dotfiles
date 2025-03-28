import os
import re
import requests
import time
import random
from variety.plugins.IQuoteSource import IQuoteSource
from gettext import gettext as _
import logging

logger = logging.getLogger("variety")

class LocalOllamaSource(IQuoteSource):
    def __init__(self):
        super(IQuoteSource, self).__init__()
        self.quotes = []
        self.ollama_endpoint = "http://localhost:11434/api/generate"
        self.model_name = "gemma2:2b"  # 根据实际安装的模型调整
        self.generation_params = {
            "temperature": 0.8,
            "max_tokens": 200
        }

    @classmethod
    def get_info(cls):
        return {
            "name": "Ollama words Generator",
            "description": _("Generates inspirational words using local Ollama AI model.\n"
                             "Requires Ollama service running on localhost:11434."),
            "author": "Your Name",
            "version": "0.1"
        }

    def activate(self):
        if self.active:
            return

        super(LocalOllamaSource, self).activate()
        self.quotes = []
        
        # 生成短语
        try:
            words = self.generate_words().strip()
            self.parse_words(words)
        except Exception as e:
            logger.error(f"Ollama生成短语失败: {str(e)}")

    def generate_words(self):
        """调用Ollama API生成短语"""
        prompts = [
            "写简短的50字以内世界名人说过的箴言，这些可能用于Linux的 fortune-mod应用程序。不需要Markdown格式，仅以纯中文文本形式输出信息",
            "写简短的50字以内世界名人说过的励志格言。这些可能用于Linux的 fortune-mod应用程序。不需要Markdown格式，仅以纯中文文本形式输出信息",
            "写简短的50字以内克服拖延症的方法，这些可能用于Linux的 fortune-mod应用程序。不需要Markdown格式，仅以纯中文文本形式输出信息"
            "写简短的50字以内激励自我输出内容的技巧，这些可能用于Linux的 fortune-mod应用程序。不需要Markdown格式，仅以纯中文文本形式输出信息"
        ]

        try:
            response = requests.post(
                self.ollama_endpoint,
                json={
                    "model": self.model_name,
                    "prompt": random.choice(prompts),
                    "stream": False,
                    **self.generation_params
                },
                timeout=60
            )
            response.raise_for_status()
            print(response.json()["response"])
            return response.json()["response"]
        except requests.exceptions.RequestException as e:
            logger.error(f"API请求失败: {str(e)}")
            return ""

    def parse_words(self, words):
        """解析生成的短语"""
        
        try:
            words = words.replace("**", "")
            self.quotes.append({
                "quote": f"{words}",
                "author": "AI生成短语",
                "sourceName": "Ollama"
            })
            logger.info(f"生成短语: {words}")
        except Exception as e:
            logger.error(f"短语解析失败: {str(e)}")

    # 保留原有的搜索支持方法
    def get_random(self):
        # 生成短语
        try:
            words = self.generate_words().strip()
            self.parse_words(words)
        except Exception as e:
            logger.error(f"Ollama短语生成失败: {str(e)}")

        return self.quotes
