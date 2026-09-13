class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghfast.top/https://github.com/turbot/steampipe/archive/refs/tags/v2.4.6.tar.gz"
  sha256 "fa685e46d435a9eb59d3e69bf718bf19bfeac17764c616fa93fd9ce5c5d9cd80"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d449b3f5a97371b28996025748a3647042ca4ad84d6b7f45ab36dacab9da21f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b444d07e72928db3020117ed2bb67d205ba99b6b075b44ae0076ab0833f0cd04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "704b284ee66f3c2b4e814dc638a47c9b611a5cc43577aeabca6260ca9bef55f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "49bd2ca54ee8f7bacb8f19b7874c1f094d1a70047cd20039cf033003da014932"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6638a5a6b240261092e961dfd9d78cba9ad8fef1d3a9e1e6dadff2bef17c213"
    sha256 cellar: :any,                 x86_64_linux:      "602cfc8a1cfb16c4d94d8e5ee798d2a54bb2c4425cbd9dc9070606d4808042f8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "http2legacy")

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match version.to_s, shell_output("#{bin}/steampipe --version")
  end
end