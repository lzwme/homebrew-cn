class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.56.0.tar.gz"
  sha256 "7d0a0d30dace5238b005a7d2209c6a77bd178f19427f0fbabe945b39dfec221b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82482a09762e6718736327edd5cbf5d0efaabac5dcf398a7c055b37244b9ccbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9d38ba0b23865b812f3b78c647e3cbe8fbf56c5a7aec3dbe0d77db6f3af4567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "656e14734c549bce8cae5b94dd599176a6955015d977d56b8240362dcca9ad9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd2de072f7f4cfc092d388e56f1fd9c32fd719ff34b78d1cd186be0d8624eec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a95d343f0d3981d7c0664e22d26329c6c17716a1c7b67af01c8bc5978c09ecad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8363700579771274af9ced29c314ccc2ef222197b1343c890652e55b3adab28"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end