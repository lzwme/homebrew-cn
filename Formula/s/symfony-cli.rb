class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://ghfast.top/https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.22.1.tar.gz"
  sha256 "0df311c0ff87d33b7bdc55bd5247629df2781b424df683ee8d8a4b5b8944c1d3"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d42f6395c650e7fcb8cc37348bb02d3c6289d0246f8f9cdf01c0ff61ee748306"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3aceaba46f2eed7b8a4cef71f2d4992b3c73e4e4d5ed7f32b8c21c57a4988593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf68dc610e5b1b9bd0b093dfe7eba1da534ba38820dcf21e46ab3b8122fa0c18"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4e9b8e02e30a03c057bf15c7ba7f9457332e638b20b00c4ac900cc347726a2d2"
    sha256 cellar: :any,                 x86_64_linux:      "11c4123a7b9ec68c0aaeb0fa9b8b9aa02f58150ef4c5a239390c7335514b8ae2"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end