class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.339.0.tar.gz"
  sha256 "7bd33e5fc9fe9609ddbedb9d42edf05d16e4c26551811d6b20d7de20c7b8355b"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9afb1764e8c68b161ddb04e9e69dbe50b81ffc0099161e1f4768e500d990505"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78dc57bd4e6a069ef4a079c286bdd6225c440976c943190fb8d984f1d61412e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9728618bcff7a1d5f3fb3bfb1b913a16b2bf75ff48951ed6de71ddd04040ed13"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bfce8d38c27737d0d41d8e85bee39c3f37f1dc93688c2bd49b10e45bf0ffcd2b"
    sha256 cellar: :any,                 x86_64_linux:      "169e82e1a489367c115ba08e945301ef0d5dea5d9ab4573ef9286bcd8c3565af"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end