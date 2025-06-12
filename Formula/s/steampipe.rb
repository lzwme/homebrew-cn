class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv2.0.1.tar.gz"
  sha256 "d9ef636ac596930fe88741fd3e9703df802409f17e6e2ee31648f075590d0f46"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe10140fd0ff7ddec5f7eee3c0055ff1b6ea65c25493ffaa98d302d8aa2fc55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20218e3ecbaed55408e9e861ab8899cd1beffd66892a0f518867d9260e41f8db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4875653d0d2ca1a724500d57500bc26fd96d12c7b1eef802ead765e76c51f5c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e98fff514b11e556bb4927b8b539d1302afe3a2a127c10ab0d364a91199667c0"
    sha256 cellar: :any_skip_relocation, ventura:       "6962b5065285ed1da4e40a595827d79fe6cdff363cbee9d98f76b0afa1758ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d90a0be1f744d0b006ba363c1ac902d56b9fc989b0377fa00e405e372c27bd7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin"steampipe --version")
  end
end