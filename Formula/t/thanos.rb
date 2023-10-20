class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://ghproxy.com/https://github.com/thanos-io/thanos/archive/refs/tags/v0.32.5.tar.gz"
  sha256 "929be4a3e8a059b2938d2d7d3f7e5428d2d9a804c3e07f8c05d8e2639ec1e689"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44699ff43e0c9fc8a6b15c7bcbb7d8534dffa72335a1557edadd25d2e43aeed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9789bd376174d9b1a39f52937abf2b08b1eeaed5691c017205a0ec5c858c113a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15c8b688bebea12602bd7e5361eb7d323b0d040dc2ebdb785a0da01b3fc4f0fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc830c9a84d8a08cdf156994779b33622888a79d714075def1b768087e49f68b"
    sha256 cellar: :any_skip_relocation, ventura:        "7407b12553f50ffad7ed0c481012cfe4b690e632c6f98785bf3b7c251981051b"
    sha256 cellar: :any_skip_relocation, monterey:       "abe4d4cdf9d71c001b6dc095c534c037e508191244093a46abab88e5692a45f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313e1893be682c4a57e50fc39cc62c4e32fa28bea88e77af5593a3a703bb3db5"
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