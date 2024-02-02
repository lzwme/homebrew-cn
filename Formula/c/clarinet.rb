class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:github.comhirosystemsclarinet"
  # pull from git tag to get submodules
  url "https:github.comhirosystemsclarinet.git",
      tag:      "v2.2.0",
      revision: "5b3fdb8a9e686d060ff1da71c5f4ae879f001f39"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db6fc59abdbb614d086ea530c81d0eb6aa59743aa1cf645d102d311766f4052a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c51cd910c688145555202d6ea539d14a51d49c413f22d64c24cc8f1499bfa87e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ae680da1dc38e44b4479cebffa414d5061478e6ca76ff1dc62fa600cedc5a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bc463f99f082f2c9d73af1b235e8a2cca794842044c9b3f03becc2bfc0fd59a"
    sha256 cellar: :any_skip_relocation, ventura:        "4a09ed858e7fec8782d1b8f374357491e3cc6646ab456cefbe8b9393f65712da"
    sha256 cellar: :any_skip_relocation, monterey:       "ec48599d506e37ffa6eaf7b1c2cc00073c484e60bd3dbe189d1b1585081b25e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb7a73134798cf7dedf0ca3323293e2ad6d4e27e175459bfb7d2c7b07978e12"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath"test-projectClarinet.toml").read
    system bin"clarinet", "check", "--manifest-path", "test-projectClarinet.toml"
  end
end