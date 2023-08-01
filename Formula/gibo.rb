class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://ghproxy.com/https://github.com/simonwhitaker/gibo/archive/v3.0.5.tar.gz"
  sha256 "31ee2e24054907e129b8e9329613461753a110eb9173565f164af4b797cbad20"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20c8b3d7d3a1999b6528326ea59dcd3cb428a5395895a7ef042f636539c4758d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c8b3d7d3a1999b6528326ea59dcd3cb428a5395895a7ef042f636539c4758d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20c8b3d7d3a1999b6528326ea59dcd3cb428a5395895a7ef042f636539c4758d"
    sha256 cellar: :any_skip_relocation, ventura:        "46a89c1b7f91d5c03771df924d3ceab10c93d53b06cebe6c41299fac66d438f2"
    sha256 cellar: :any_skip_relocation, monterey:       "46a89c1b7f91d5c03771df924d3ceab10c93d53b06cebe6c41299fac66d438f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "46a89c1b7f91d5c03771df924d3ceab10c93d53b06cebe6c41299fac66d438f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f759205b098571f8ac2b8cbbab23f18bdb4fc338b93c8aac04874e5ee8276ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
      -X github.com/simonwhitaker/gibo/cmd.commit=brew
      -X github.com/simonwhitaker/gibo/cmd.date=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system "#{bin}/gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end