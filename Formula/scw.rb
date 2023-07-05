class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://ghproxy.com/https://github.com/scaleway/scaleway-cli/archive/v2.17.0.tar.gz"
  sha256 "41db6a308377219053938907a925cd6b6cd14f4cb49c690de6b92b763b94bee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85eed7d2fef279312f00abd59c0893c8f5ee5123b24f9d268c62f5aed9ce4bcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85eed7d2fef279312f00abd59c0893c8f5ee5123b24f9d268c62f5aed9ce4bcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85eed7d2fef279312f00abd59c0893c8f5ee5123b24f9d268c62f5aed9ce4bcb"
    sha256 cellar: :any_skip_relocation, ventura:        "594c30f4b5b12f294be8322cd2dd76b6c2b86bc68bfa2d6e51b1c3ef009c73bd"
    sha256 cellar: :any_skip_relocation, monterey:       "594c30f4b5b12f294be8322cd2dd76b6c2b86bc68bfa2d6e51b1c3ef009c73bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "594c30f4b5b12f294be8322cd2dd76b6c2b86bc68bfa2d6e51b1c3ef009c73bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6bbd2b566eb2954854fdbe73de438fe1c034ad7680203dd93a91d66bd9b7974"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end