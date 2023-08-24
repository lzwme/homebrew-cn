class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://ghproxy.com/https://github.com/thanos-io/thanos/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "be4e2e429dbbb5d7988f8641ad262bbbff1ebf356a347caf8be86d123e3f39b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfd61eee84a6d806cd87c12edfa4dec30fbe144bba9ddca0b223753292285056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bcfc6b6a025caa162308f4f9d45bf0626cea530f1f193a82a6be50741542170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae61d4e81c5da710795b456c0608567f0d7a90a1596cfebc29f1397acee392f0"
    sha256 cellar: :any_skip_relocation, ventura:        "875fad7cc2e6774a38972e0e5a642ad2af449d41f740d52a62961b008907a134"
    sha256 cellar: :any_skip_relocation, monterey:       "44562d3686135538897f50aa5cb91540d228cc8b03d6c960f32b010d75c9a67e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f44c387e04e98b96d7a1fd3541cbcd27e9320f8889dc9bc9a3a9c9c3ea9ebc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "343e1f9aa6d3c9e8741f9c95f5a44a1c8eecacfa179b2157b6cafa336ca6f62e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end