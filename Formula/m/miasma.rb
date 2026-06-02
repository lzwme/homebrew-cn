class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://ghfast.top/https://github.com/austin-weeks/miasma/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "a80b21a4fcba442d91ebda94c061236b62ce32407046cce83af4da2d4468a382"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f780e87218d8d85ed91b438c8ac14be9a0f04e92c7e70110323f68ac311350c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc8ceda7472a3e570a073e2226c80c55a78720b167e2474657dc6ce92e56fd53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f95c0c0a6e473bfe27febd47523a8eeef365eac1b3c045ba8bbce5c777a4a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d97a854acaf4d189c9fe123ffe376cecf6c39f02360bf2f4c8c0e8fbe9acbc2b"
    sha256 cellar: :any,                 arm64_linux:   "7dabb755c9056d5f1a1c20b24591ac8f626b4d5e7c6168622ecda84baacdb205"
    sha256 cellar: :any,                 x86_64_linux:  "be264adb5ac97eb918535bb5a7c9e803e97093d609bfb54e1f51771cfe4ac553"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end