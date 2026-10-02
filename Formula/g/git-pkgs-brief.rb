class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://ghfast.top/https://github.com/git-pkgs/brief/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "c5b9e56fac95826fc9a26e3c0427ce08ca1b7ce6f7b1c316270c316a8bca9741"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c19ece3b346ca0dfe099ea827094fb085c6f8d54a4011f8471d73f6bf48af487"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c19ece3b346ca0dfe099ea827094fb085c6f8d54a4011f8471d73f6bf48af487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c19ece3b346ca0dfe099ea827094fb085c6f8d54a4011f8471d73f6bf48af487"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9aed02561980f9ba2603b69820e5ea72d16bd00dbaf1f8c120533ca424829426"
    sha256 cellar: :any,                 x86_64_linux:      "edc0ac1817149b6336e070cba0494fd4352f401b5397f6c4ea395ae22ce171cb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/git-pkgs/brief.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"brief"), "./cmd/brief"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brief -version")

    output = shell_output("#{bin}/brief https://github.com/Homebrew/brew")
    assert_match "license_type\": \"BSD-2-Clause\"", output
  end
end