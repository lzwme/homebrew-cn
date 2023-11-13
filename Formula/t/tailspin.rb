class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://ghproxy.com/https://github.com/bensadeh/tailspin/archive/refs/tags/2.1.0.tar.gz"
  sha256 "a9968b30a8c20cb97e2a38d578e10a45ce069639922c92994fb94a95817a77e4"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbf850c8d23295a9f15dc4b837eac27f3f4f9517c3e1d04d8c6a848cf1666cc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90da36ca7b9b2ebd725ca509ef6660070482f7ee70a214c8b2c8078fd7f9faaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62242ca59b32c198cf8a01d02ec330e1baac8fbbf0675fdee6cd67e9ba914051"
    sha256 cellar: :any_skip_relocation, sonoma:         "f96466c749ac92e1d491f3aaac100adc173a1074b296decbf0bb48a631e48862"
    sha256 cellar: :any_skip_relocation, ventura:        "946c187e34c40d8a20488459f6b27ae92cbda8df72246e5cadb6fdb13e6057a0"
    sha256 cellar: :any_skip_relocation, monterey:       "4694f8519eb7b444854c09a15f575abc2abffb3c77b645c2db7644fbb6b2c82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43df054b9094b35e7636f643e37ddbc4b7def4aaf09e7a39fce64db023e8ac67"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/tspin --tail 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/tspin --version")
  end
end