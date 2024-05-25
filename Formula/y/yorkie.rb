class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.20.tar.gz"
  sha256 "97d81d8216a7d011fed3fc7820c7878d7bd5d6257311453f0d13c858a73e6e34"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c195246d1a644e0a867219cdbb88394021e0de6439544504a3b5c31f4aa55eaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0caea6580d51bfbb745345b41673119e6dd4511b1d024ccedaf2b27d68d965b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c1bf9792f0fb4f4563289a22c2cdeb55676b1c4f9d35cf8d02190e9f2998e13"
    sha256 cellar: :any_skip_relocation, sonoma:         "e741dd2f642118c82d2f7d64438baffa0b9ce155c7c9312f2c2bf4838364dffa"
    sha256 cellar: :any_skip_relocation, ventura:        "20416e1d2c1473bc47505ef9a1f012736681f6edc4623859c6bed23c5aac8aa8"
    sha256 cellar: :any_skip_relocation, monterey:       "18574e3f81eb549746830c09364f6728d8c51db553aad0fa2a5337033ff386bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f729b94cf8c141a9406d451a3d41a8e5fc60dd1dd3835a5eda737280bac3351"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comyorkie-teamyorkieinternalversion.Version=#{version}
      -X github.comyorkie-teamyorkieinternalversion.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdyorkie"

    generate_completions_from_executable(bin"yorkie", "completion")
  end

  service do
    run opt_bin"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = fork do
      exec bin"yorkie", "server"
    end
    # sleep to let yorkie get ready
    sleep 3
    system bin"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end