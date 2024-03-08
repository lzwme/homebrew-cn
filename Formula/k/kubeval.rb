class Kubeval < Formula
  desc "Validate Kubernetes configuration files, supports multiple Kubernetes versions"
  homepage "https:www.kubeval.com"
  url "https:github.cominstrumentakubeval.git",
      tag:      "v0.16.1",
      revision: "f5dba6b486fa18b9179b91e15eb6f2b0f7a5a69e"
  license "Apache-2.0"
  head "https:github.cominstrumentakubeval.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e54797aba1cf7170e6b5ff8d0bb2584f38cb9b06bfeee5d20066e80be5e4f03e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b431a6bc542f5d5fa271e5a246d91ac1b08a1c72bbfad9170d2bf4987c10868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e5974f57b949750e5b87e0d8b4cd7e12c566e29bdbd00d86cb9d132ee8e50d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33bc6b830f27fdace62339ec2d3ac3ff01424c868e573f1d290d2f469c4986e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3055bd5d0907fad4c1ac5a4860ad52a4d765692f28ad363318ca496ab4a0628e"
    sha256 cellar: :any_skip_relocation, ventura:        "567e2a64ddc319bbf181fd2578489be371810321339892ce786b9196edd924f5"
    sha256 cellar: :any_skip_relocation, monterey:       "01c06b669351b172306258e588e035c21d84a0385a611c7174ceee0b2809a411"
    sha256 cellar: :any_skip_relocation, big_sur:        "542fae8921857d0adf7424fde1c08d2f4894989770515fa24591d93bd8334c65"
    sha256 cellar: :any_skip_relocation, catalina:       "1945e1dfa19fd19f8a850156d984cb2bb8abe6bdcd29f79b674bfbce5e5abf96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c4fe8b9a551d9f7a4fa58b620b703db28df4b422fc7740442b062ff5fbf31a"
  end

  # https:github.cominstrumentakubevalcommitfe0a7c22b93b92adfdc57d07b92d5231fd0b3e0e
  disable! date: "2023-10-17", because: :unmaintained

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "fixtures"
  end

  test do
    system bin"kubeval", pkgshare"fixturesvalid.yaml"

    assert_match "spec.replicas: Invalid type. Expected: [integer,null], given: string",
      shell_output(bin"kubeval #{pkgshare}fixturesinvalid.yaml 2>&1", 1)

    assert_match version.to_s, shell_output(bin"kubeval --version")
  end
end