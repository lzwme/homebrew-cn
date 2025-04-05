class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https:aquaproj.github.io"
  url "https:github.comaquaprojaquaarchiverefstagsv2.48.0.tar.gz"
  sha256 "39ce65ebe390dad7801e75c413eea04bc6d57d110784d6f7a5cfeebfa7d96c4a"
  license "MIT"
  head "https:github.comaquaprojaqua.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3090ed9a2dd7c521f1f442bcfe54f79f72ab1dcb681e71ebde90d54712c05d84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3090ed9a2dd7c521f1f442bcfe54f79f72ab1dcb681e71ebde90d54712c05d84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3090ed9a2dd7c521f1f442bcfe54f79f72ab1dcb681e71ebde90d54712c05d84"
    sha256 cellar: :any_skip_relocation, sonoma:        "280077101d3424464569ae7898894fdce801489aedaac5ae159f4ec7ea548b65"
    sha256 cellar: :any_skip_relocation, ventura:       "280077101d3424464569ae7898894fdce801489aedaac5ae159f4ec7ea548b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a98c32af11852f0e0027957aad6abb1b826f051c168e5a0cc3024143ea74c665"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdaqua"

    generate_completions_from_executable(bin"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aqua version")

    system bin"aqua", "init"
    assert_match "depName=aquaprojaqua-registry", (testpath"aqua.yaml").read
  end
end