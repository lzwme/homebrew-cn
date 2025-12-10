class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.41.tar.gz"
  sha256 "d2888a6bc774aa7089750a7c171a76f79716bf9f6fc918017a02b386fc0f672d"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "482e62b415ebfe784a5d860a096512012377ea965495bb6bd8b2ac3c4c75fc78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d03a04ee98ad21e42e28669276c3c044f9da9ddbd49c2c63b6c05867cb081eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "820a76b5bab06589659d26932a1e7e9dd326e0eeadc50b447726d25e41937fd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4700ac51abe72556ab203a4d23815b9da1e0279671a4286264b368af6b523c43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e169ab3f7cf379f0e394237e12f9bc8eb7bd894b6058b1906e4ec35c6df59b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12db579f7e0533d8670e212db36a8c54dc1fe733886f81714cd3dd19851e1d1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", "completion")
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin/"yorkie", "server"
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end