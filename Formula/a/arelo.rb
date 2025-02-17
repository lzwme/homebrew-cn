class Arelo < Formula
  desc "Simple auto reload (live reload) utility"
  homepage "https:github.commakiuchi-darelo"
  url "https:github.commakiuchi-dareloarchiverefstagsv1.14.1.tar.gz"
  sha256 "ad01be3582f0a89fc74907b488a1d19467c24c65f53415cf4e05a62fca58a6bb"
  license "MIT"
  head "https:github.commakiuchi-darelo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "004dda4498091c9e31eed59807f4c927f4a6bb691f97102604c7f81e6dc3f32c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "004dda4498091c9e31eed59807f4c927f4a6bb691f97102604c7f81e6dc3f32c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "004dda4498091c9e31eed59807f4c927f4a6bb691f97102604c7f81e6dc3f32c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8656cef98a651a508f92fb61044308241002f8e8804b3ddc8922a4efc26cc9d"
    sha256 cellar: :any_skip_relocation, ventura:       "b8656cef98a651a508f92fb61044308241002f8e8804b3ddc8922a4efc26cc9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a84420a3ed2428661d3a81a173872cce1aeea4a6ca383e11ba48a047f557cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}arelo --version")

    (testpath"test.sh").write <<~EOS
      #!binsh
      echo "Hello, world!"
    EOS
    chmod 0755, testpath"test.sh"

    logfile = testpath"arelo.log"
    arelo_pid = spawn bin"arelo", "--pattern", "test.sh", "--", ".test.sh", out: logfile.to_s

    sleep 1
    touch testpath"test.sh"
    sleep 1

    assert_predicate testpath"test.sh", :exist?
    assert_match "Hello, world!", logfile.read
  ensure
    Process.kill("TERM", arelo_pid)
    Process.wait(arelo_pid)
  end
end