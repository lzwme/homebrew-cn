class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.36.tar.gz"
  sha256 "5b8aa657414c3ebee2b42df4e50bf02c2b4edacd55418649e7d5cb5efc1b0fec"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e9b4ebebc4602b71e9434812a8c42a816098fe0ea76ceb7f91e652fa39aac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2cc396360c9e25016d21f89396fb9643e5ddfcad1fc7200b8b1ccd129312022"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9644f657e56b64395f6e2facfb3ba050fa7ac32285a454d1f505702d893bb09e"
    sha256 cellar: :any_skip_relocation, sonoma:        "630e40313a07e238922ce6d700b1fb28c6e82b3711174605cbb74b90e4ba3df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a3dc63f7c0b02f0bbf73ecdae4ec1ce187c41192962f6bfc96c68ef6cb3eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280623776ccf3b3263038614a8c925ae8582cf68acad47b7a87fe2e592994494"
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