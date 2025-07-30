class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.22.tar.gz"
  sha256 "bc8cb4c56b02e262a70b1acdd9161c9c6079b91ad912b09d5980eb88ac1f03d4"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142932eed1e6a3da30a6cf36af6cbde487f3c7242517b241d4dbe30a6e63ecb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7089e4e0ebbd695c18fb6d0f8f7baebf9f5490c9f1841319accac8e3772964b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4944df782840236ca86d5cd0a98165c168c1ae7617d386d9edf4a59c1193b0ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "2962687a66098dec0d0f3259fe1353e8287dc9cd778c7c0b8ea24568f9c74bd5"
    sha256 cellar: :any_skip_relocation, ventura:       "b07f1623168473e52dc2e722853a3408886b793deff652a63ef6d270cdc64d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5b3a2b7442a28efc372b1e4827b265231ba81337edb6cee05198dc92cd47d05"
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