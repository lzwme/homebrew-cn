class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.2.tar.gz"
  sha256 "7fbef043e02188e65b9b195155113679421f55a72436160ed6c74af721f44de2"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bae12c4a26b1c52ea0afb13f2776a0fd462ee7f253c5503d0192d2c7ed5c344"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "450d714d4bc465f8990b4b1a0e4a9c997b8abe462ecab745def1d77803f98324"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c00dddb10fbf700849ef12ad0839c24e69a86dd2056c8b76d0c1f09077198e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bef7292502842428ca69ba69948e25a6db646b17d13ce03f04af4ed3fe6bfcf"
    sha256 cellar: :any_skip_relocation, ventura:        "6211e87a1e40c2ed1616aaa8a88b4eaa74d112e359b2e4f9ea05aaee9ecf17c3"
    sha256 cellar: :any_skip_relocation, monterey:       "2446424920344a17d9f90cdb94d4fcbd2ef8aa437ac18831cefcf73de34e3102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b053b3c8caa9bff968976bde63bad3b28b72419bfae30889bb211dc3bb52f516"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end