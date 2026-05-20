class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghfast.top/https://github.com/turbot/steampipe/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "0fb7cacbd6487667fa7ebd590fa110c2e7364ed6323ae1c619415915f9685025"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6db38b24f7acd85a9df7fc3c174c96f29769a88aca3c2830d4c66758eb54c726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eda5a7c82d70cfea85bfe33a9e6904e07f0db7e311c3c06e0c342462b1cb5e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5c152399e71f6699448fa429710fb0000d706ee735dbc225f37b7c4d297917"
    sha256 cellar: :any_skip_relocation, sonoma:        "0977493cdfaab98d6ddb994321ae199eed5d8d60555ff60302cd1f4e969c591e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b7e3fc51ab498d4568132ec79524bfc87ef466942dc8f3c05b247d9086c000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "485c975d6616a114de8cee15f60573bbc0d4cbde3632ef75867b5fe6b146d0dd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end