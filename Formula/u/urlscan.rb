class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/5c/d2/3e3923b54bd185352b68359f60728529c0eae30fcef8e01eee0e7c3978af/urlscan-1.1.2.tar.gz"
  sha256 "e4f01037dcb84f0cc5733b9423732ebf368cb9b4c9714bdaf7dd336d883a78b2"
  license "GPL-2.0-or-later"
  head "https://github.com/firecat53/urlscan.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6beef329e0a219493eb3e2bb95bf3a05538b2a25361fb07a43fdcfd1ce5ca49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b12eede310eabbef546ca8494148daf86b5f16928e904d9fe4bdf9d539648d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "daf43668d4e0c86590b4bba564fecd92b7b814a583e2ed3b390008838a7fb398"
    sha256 cellar: :any,                 arm64_linux:       "d73d2956c3b2ba9849c41dbfb8cc771b48615a29d1dbd191d54914c84b90052b"
    sha256 cellar: :any,                 x86_64_linux:      "4f3cacfc50827dd5c1d028cf1b8b4939874c0d75e76a5cf9ae3aa49922242f39"
  end

  depends_on "python@3.15"

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/3a/df/eb5dcbdf1638c38618096382b4a30b0423ed7d2aac97fd9469b51d6de43f/urwid-4.2.5.tar.gz"
    sha256 "a1fea3a551953fae4e6b727536334233bbb8b88c45230bc91d9751b402a8c16d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end