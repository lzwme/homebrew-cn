class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.68.3.tar.gz"
  sha256 "4445cbf395f9acefda6aedba24c401f3fd08d7ef66083a30a17138ba1f6dbf97"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77b345dff9e77d084bc4f7b5595ae501ffa54630f9ff079df7683fea4d115973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b345dff9e77d084bc4f7b5595ae501ffa54630f9ff079df7683fea4d115973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77b345dff9e77d084bc4f7b5595ae501ffa54630f9ff079df7683fea4d115973"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcc7b731ead2574e04b14f8b09154f3c1fc344e9bf4601c60e8e5d8de9e0fc37"
    sha256 cellar: :any_skip_relocation, ventura:       "dcc7b731ead2574e04b14f8b09154f3c1fc344e9bf4601c60e8e5d8de9e0fc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdef6cc87ee0b7968c786d6b14687b896a1fbbcfb75ea2444bdd8423a1e51cec"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath"hello.txt").write "hello\n"
    copy_command = "#{bin}o --copy #{testpath}hello.txt"
    paste_command = "#{bin}o --paste #{testpath}hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
    else
      system copy_command
      system paste_command
    end

    assert_equal (testpath"hello.txt").read, (testpath"hello2.txt").read
  end
end