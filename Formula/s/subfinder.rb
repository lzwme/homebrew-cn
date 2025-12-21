class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://ghfast.top/https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "2d053b6ed20ebedbff4adc0f4efcd80e4da3e6efc5289c065271f08755344120"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42eb254129769fb86c1d4ba979a5412896991b8549e2bb226f075472e80dd428"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f371c5f20d8999d8865198d5d497629bc09a6a42b6d979a6e750deacc90c74d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "698030463ebced9450fdb709892579a9d6c3f5faf352a4f12f3e779f1793992a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbe3ec41e7e4fc26b60c7d84fa4d091659f6d857a7f46337efdccb0457ac519f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "275d36473a53974844e9728d6884caf6e71cd766933b16c46fc829dc944c4007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d837503105a14399d22b78e7fc2b04e2cac9c5c265a4cade79b1cc45315d65"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/subfinder"
    else
      testpath/".config/subfinder"
    end

    assert_path_exists config_prefix/"config.yaml"
    assert_path_exists config_prefix/"provider-config.yaml"

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end