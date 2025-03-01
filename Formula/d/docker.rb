class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v28.0.1",
      revision: "068a01ea9470df6494cc92d9e64e240805ae47a7"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce6746f4260d1af97c4a0cc96dfa1108ead7826491be28c888a0f5e7aabd2a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce6746f4260d1af97c4a0cc96dfa1108ead7826491be28c888a0f5e7aabd2a57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce6746f4260d1af97c4a0cc96dfa1108ead7826491be28c888a0f5e7aabd2a57"
    sha256 cellar: :any_skip_relocation, sonoma:        "817933212d839ace0e6f59ebed686c496947260c41ea48224a7c04e2ddd35cb8"
    sha256 cellar: :any_skip_relocation, ventura:       "817933212d839ace0e6f59ebed686c496947260c41ea48224a7c04e2ddd35cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2458e35c71221b8cf4678e7cea2c84c02b67e58f1dfa20efe05ece4b3cbc843"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  def install
    # TODO: Drop GOPATH when mergedreleased: https:github.comdockerclipull4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath"srcgithub.comdocker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.comdockerclicliversion.BuildTime=#{time.iso8601}
      -X github.comdockerclicliversion.GitCommit=#{Utils.git_short_head}
      -X github.comdockerclicliversion.Version=#{version}
      -X "github.comdockerclicliversion.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.comdockerclicmddocker"

    Pathname.glob("man*.[1-8].md") do |md|
      section = md.to_s[\.(\d+)\.md\Z, 1]
      (man"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}man#{section}#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}docker info", 1)
  end
end