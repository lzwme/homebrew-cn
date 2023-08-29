class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://ghproxy.com/https://github.com/thanos-io/thanos/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "524503d3d4606799e6f5d6b9e81aa9f816284267ceabf041ab5d799925c3b05d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c7e27873847a4126c826fabfa75b36eb14d9b6c823002874e1c8aa9addbb72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efcc46d366c00622f7e5d4718a78d7abb897ba3889501ac867e6bc656da52ced"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a2f0795f5a89d0eb6f8465ec13aa1ad4018072528f378bc097f79f0eea15847"
    sha256 cellar: :any_skip_relocation, ventura:        "d9cf58ad686c35f6bee48aa0104b90aabe01d3af767802969118a398dcedab8b"
    sha256 cellar: :any_skip_relocation, monterey:       "88b2193f9ebc9394126a6bd98f3459284438162938e8d0243a809175b843f84e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4aaece2fbc829949e5d004cae3b4a4a6a79a9e0bfba61e90ca612a88779dd33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f2517d4f989cbafeb1ac6f244ccf2efbdb2908f8949e75d113d20622f21fd6"
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