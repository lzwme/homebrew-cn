class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghproxy.com/https://github.com/open-policy-agent/opa/archive/v0.52.0.tar.gz"
  sha256 "ffdd7df0742385e46459f7c79149c9b4bacfa062f0cb58b174516c408e5c8024"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7d0c8f47bc6e40a1af433e412de70ef9108d541dd85a92ceaf32651194911f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bce2343d6a0cfbf520155e7473d9fd44019d18257e9138ac263abf526e6420d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76661a03583fda31c637fdb80201cc94e438ce8cd542687d64d0e71039c7e733"
    sha256 cellar: :any_skip_relocation, ventura:        "db91dd7c89fcea123e9d70da4459c1f8b5e0f85342b9a667d46b97a992248793"
    sha256 cellar: :any_skip_relocation, monterey:       "f08a1226a255c3b016d013856165299354f33d7a4b3addec8ed875a74e77b259"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa4199fb672144a7417d66babe1c2d0b5bdeef598f1280388ad831702ad73ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165cfc67e8b6c988e648e75448a52c6ed297e36c3b2ba185d9cb16ebaedb18b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end