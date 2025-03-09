class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.3.17.tar.gz"
  sha256 "18f2ded1b263ccff74c93ec5973c43618934c8427e11a400d94b15c75f16ce49"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec8f30c31f1902c0abcc1b0424b0c3a67846945f572c0a22e72410fd328a5ee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58d9758575b99d90f9681be588fc7ef440f9d2439f136e02e9b2f7ba377c570c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b530e727c7d19f1da0b92c5798e1af9f2fe3a3ebb461f52fc29d9a2aca61e9ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "46e230a6bd722c315a653237fc3bd6df3798d7b18aacf625c0433a317b5e5301"
    sha256 cellar: :any_skip_relocation, ventura:       "8b6ef616e3ab6e665618256aafd206527b9317ec0ee9b971f2effb02e5d505a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31f0f42d0b31ccbbe351db32d632ac57c1c2d50447bf3242df361d8c2b5a88b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comOpenIoTHubgateway-goinfo.Version=#{version}
      -X github.comOpenIoTHubgateway-goinfo.Commit=
      -X github.comOpenIoTHubgateway-goinfo.Date=#{Time.now.iso8601}
      -X github.comOpenIoTHubgateway-goinfo.BuiltBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
    (etc"gateway-go").install "gateway-go.yaml"
  end

  service do
    run [opt_bin"gateway-go", "-c", etc"gateway-go.yaml"]
    keep_alive true
    error_log_path var"loggateway-go.log"
    log_path var"loggateway-go.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}gateway-go init --config=gateway.yml 2>&1")
    assert_path_exists testpath"gateway.yml"
  end
end