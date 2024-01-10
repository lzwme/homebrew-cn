class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:github.comreplicatecog"
  url "https:github.comreplicatecogarchiverefstagsv0.8.6.tar.gz"
  sha256 "e1ad2ade63c53934a09588a2d02d3d46c838438b549476c584191e53855753a5"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c9ada2372f7fa68272284c6d3cbc6cfc6dbeb84cbc796cf01f378e5aae2b580"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d25a591f7726b31db6a76894643abb62a2584d84d7eba5ecce0ce47d187771c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0291169df610cb71b89a0190c18591ada2d171224c6390590bf595eeb0f800f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7483d2c43f5bcc8c4847e868a00eb3bf73dc345efbb72ecb363c490b3b25b392"
    sha256 cellar: :any_skip_relocation, ventura:        "63de712f347c7682087b7751372c83df6c436c606ae3441db263c47094d2ebc6"
    sha256 cellar: :any_skip_relocation, monterey:       "75b0beb58c4aa5182560ab3348405ef2f187b97b208cac5b72cc2fb5030e828e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d33e4891e364639a0657125a1818cd2ce30bf9b189fd92d7a91a2228214d55a1"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}cog build 2>&1", 1)
  end
end