class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://ghfast.top/https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.21.0.tar.gz"
  sha256 "90ca2a8f88a52aebaafbdb3c4ec40476ebd763b2ffac108536b1681fcc457077"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c980351a2bd583dc70ab7f17974e9f545cd1228823c91a029aee8f69f18203cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "448abc49a4e4d4b55e3b95f5728efaccf65f68e02454d3675561154d4430621c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31c489bde790c5613bca779e0af30e262598a252e1cb9d1287fc9b06977e83ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8424dd14cee025fa31b75f086dbc873735ac947611adc98bfbcfc4e4b40370d7"
    sha256 cellar: :any,                 x86_64_linux:      "215c2f42ce34a018f929097e0736f3e8de05f1b97dfe829fcca99eaf0d17ee96"
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