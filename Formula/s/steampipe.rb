class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghfast.top/https://github.com/turbot/steampipe/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "16675bfe12031d1c9f41207edf2f66997def6b893918ae65d14f05ac6353b96e"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecfa885c07a9c54926899594c4e9c90557374f0358384446b799f4faaced2ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ff6aee3ec43635316391bb380a11aaca03cd2e4bfc590e7c417c15fc80e416c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e70d9168ceeded36e95194ce626a3edbf97e598074c7059a58a40326f1598d"
    sha256 cellar: :any_skip_relocation, sonoma:        "38067174f64cffe920410309e564a3b25e4256d03cbfb3ad951aa57a73024301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8afe9f5b1b157aca15f6f28b938ac0b4c20ffb8736ccae495be31e946d76ae39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9480a5f2313aabd54166dac3113234a24842b397a6e156c05a91cb76e90eabad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end