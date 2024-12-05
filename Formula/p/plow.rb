class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https:github.comsix-ddcplow"
  url "https:github.comsix-ddcplowarchiverefstagsv1.3.1.tar.gz"
  sha256 "0ae69218fc61d4bc036a62f3cc8a4e5f29fad0edefe9e991f0446f71d9e6d9ba"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b9c5d2de7997a3f2c6808cdddaf777f87e768da1c236cd41c66da552e39096c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b9c5d2de7997a3f2c6808cdddaf777f87e768da1c236cd41c66da552e39096c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b9c5d2de7997a3f2c6808cdddaf777f87e768da1c236cd41c66da552e39096c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee01081eb578e285218f45235155d9087af4155de076de009f71ef59442ea33c"
    sha256 cellar: :any_skip_relocation, ventura:       "ee01081eb578e285218f45235155d9087af4155de076de009f71ef59442ea33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab525ddecde654379ca9f0d39daf617c981306016c4b71767146a24d92a0492d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"plow", shell_parameter_format: "--completion-script-",
                                                     shells:                 [:bash, :zsh])
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}plow -n 1 https:httpbin.orgget")

    assert_match version.to_s, shell_output("#{bin}plow --version")
  end
end