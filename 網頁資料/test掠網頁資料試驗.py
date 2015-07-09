from unittest.case import TestCase
from 網頁資料.掠網頁資料 import 掠網頁資料


class 掠網頁資料試驗(TestCase):

    def setUp(self):
        self.掠網頁 = 掠網頁資料()

    def test_全部編號(self):
        self.assertGreater(
            len(list(self.掠網頁.全部編號())),
            20000
        )

    def test_一般異用字(self):
        self.assertEqual(
            self.掠網頁.異用字(1),
            '蜀'
        )

    def test_濟異用字(self):
        self.assertEqual(
            self.掠網頁.異用字(155),
            '又更、又復、又擱'
        )

    def test_空異用字(self):
        self.assertEqual(
            self.掠網頁.異用字(11353),
            ''
        )

    def test_圖異用字(self):
        self.assertEqual(
            self.掠網頁.異用字(1658),
            '𢻷'
        )

    def test_圖佮文字異用字(self):
        self.assertEqual(
            self.掠網頁.異用字(1858),
            '𢓜、徦、到'
        )

    def test_複雜圖佮文字異用字(self):
        self.assertEqual(
            self.掠網頁.異用字(4526),
            '虬毛、𧺤毛'
        )
