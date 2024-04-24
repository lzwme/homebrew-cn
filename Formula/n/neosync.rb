class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.14.tar.gz"
  sha256 "4becbe8fbf18cfb09ffba8ec0cf308d0038daf6cc53cb76ea8c56b8d4e8bb382"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92f62f2d3fc8a7f8f22cc993cf604f66b37a7941dae12d9ab3ea94b24977f189"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2abc02c8f13bf421dcd1dc98f2ff19da7f2f970cc35a8c884de5820de9b515ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5692f06d638f94cf3227e2bed1cf9e47765029293c549c7b0d8435f42e46691"
    sha256 cellar: :any_skip_relocation, sonoma:         "260dc202071f3c557e6c8a5e03c2de60d0eb8b3ea8bf0ba6aa7ffdbe7e417482"
    sha256 cellar: :any_skip_relocation, ventura:        "991d27e40b774365da7b01a19e5595279b36fdb18ba36e31fb21f54151e00ec4"
    sha256 cellar: :any_skip_relocation, monterey:       "370fb7195df07a4673b7cdf007d2cf7abc8a32530d9c738e601bd3dacf570d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7329a0c06487ad97bc6a1fc457c3ab915ea5b76da171577a43f371e09753bf5e"
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