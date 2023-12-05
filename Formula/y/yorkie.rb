class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.10",
    revision: "1006b647b75195bfb5ff6791db672c381cb4de54"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "680ed5f1fb12c966b1a3edc653234ec102e9d02cd0890b019cfd7b6224507985"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81cfe1b06aeffc7c7ebd23e84e13329f576ae5c6c7e673a6bf8e02827ee859b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a094ccbebde7bf0eeb86c2ba99b4c0ce7865447b4876a91725f3f79dcd2e5fea"
    sha256 cellar: :any_skip_relocation, sonoma:         "97169084db75a47c21383fcfae783c2a08530cd7ebbf006ab93841c03d235ef4"
    sha256 cellar: :any_skip_relocation, ventura:        "c0781d29a111862d2dd04b6e603cec3f089703fd213cdacdcc02f35e14ff4697"
    sha256 cellar: :any_skip_relocation, monterey:       "e2cced8ab1a2b7146e089b5d0c84950a27fe5887b9b181375de71d9ec557d155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d7ef0349f3a13404637173e5a809002f29480ba0966006937da5725584fa315"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"

    generate_completions_from_executable(bin/"yorkie", "completion")
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
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