class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://ghproxy.com/https://github.com/Flank/flank/releases/download/v23.03.1/flank.jar"
  sha256 "d5c97accc9bb79ffe165fedc877b38f0ebb8284a61f1e84f1948fdd2cdcf10d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39f986bb309eeb7cad4cc8cc565e4ec19b7833b6810e5a57c284d1d88a3ba4a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39f986bb309eeb7cad4cc8cc565e4ec19b7833b6810e5a57c284d1d88a3ba4a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39f986bb309eeb7cad4cc8cc565e4ec19b7833b6810e5a57c284d1d88a3ba4a2"
    sha256 cellar: :any_skip_relocation, ventura:        "39f986bb309eeb7cad4cc8cc565e4ec19b7833b6810e5a57c284d1d88a3ba4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "39f986bb309eeb7cad4cc8cc565e4ec19b7833b6810e5a57c284d1d88a3ba4a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "39f986bb309eeb7cad4cc8cc565e4ec19b7833b6810e5a57c284d1d88a3ba4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf72c27c47733145f746887fd09e9fcbb3e6eec1bb310d12197a477d1866a03d"
  end

  depends_on "openjdk"

  def install
    libexec.install "flank.jar"
    bin.write_jar_script libexec/"flank.jar", "flank"
  end

  test do
    (testpath/"flank.yml").write <<~EOS
      gcloud:
        device:
        - model: Pixel2
          version: "29"
          locale: en
          orientation: portrait
    EOS

    output = shell_output("#{bin}/flank android doctor")
    assert_match "Valid yml file", output
  end
end