class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https:github.comtuna-f1shcyme"
  url "https:github.comtuna-f1shcymearchiverefstagsv1.7.0.tar.gz"
  sha256 "63ca7c5f473cbefb1fd07ba9b4f9693268d80560a778a001d82fab68bbd1552a"
  license "GPL-3.0-or-later"
  head "https:github.comtuna-f1shcyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5cf046552b32dff79f461d8415c5e205b1b0e3dd93c63abbf8d303160970936"
    sha256 cellar: :any,                 arm64_ventura:  "b6b22e43e3b5ac97daec01c399942bb41b34e012399e7a33ffae16386df6b9c7"
    sha256 cellar: :any,                 arm64_monterey: "216eb8147e12a0e3e1992d45ad1fbc30a94fe42eb4cf2e8319892ee6be01fa4f"
    sha256 cellar: :any,                 sonoma:         "9153dba15249d55ddc18cf9c382f05a0c0a4a24429c1cc4a2ac4c1aa9f00f423"
    sha256 cellar: :any,                 ventura:        "0445cf8da3b262f2214fbe2d7cab8f8b54027b2ee0b414998681a6416d14fe40"
    sha256 cellar: :any,                 monterey:       "61137e187437c924cdec10198b120f3c8d7ce7e621e88558237162cc774f0f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b0b0d24f40ebaa7b6c6cf4804e9e84d45e89bf7b9128a9376ed5ac6dd804019"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doccyme.1"
    bash_completion.install "doccyme.bash"
    zsh_completion.install "doc_cyme"
    fish_completion.install "doccyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end