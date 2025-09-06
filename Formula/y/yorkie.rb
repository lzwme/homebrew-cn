class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.29.tar.gz"
  sha256 "d7c7a5bed266f5ef1c4981e80347e712fceec88a7455662100f55d105f612524"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83a2fd3b359560b95d78bc918035ca8c295ea1b8050761438238e72cf945ead2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcbe0f78a75505760669e78a75bdca820df520850ca64405f094419d47db84bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61bf81e4e7540a425fc20129f9fcc7e6efa8a0898537c9c7705376679162005c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a78daa0986c6270d58512575446fbb42222dae083234bdc7b346ee888732d4"
    sha256 cellar: :any_skip_relocation, ventura:       "df4a55f6165dbf43743ad66f7047a97c3372a2c5a63563045f33ff188524c6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d8a70359dff250df21421cf5d63991c7f528a5a026e6019f0ed493ed7d56ac"
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