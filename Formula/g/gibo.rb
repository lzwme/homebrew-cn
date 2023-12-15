class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://ghproxy.com/https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "6402e74267edf595b222a5a0bdd431fe734df8fde0c7909e7c0f042c37712dd5"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "837eb02cf6d38ed6ac035c87469c908d98b4ef3b1d3082020339c94d22cc9278"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66fcbcecb80a0cc49ec953138634a6ab043189536a0fe1f8f613cd0822d28102"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04b5bc27a88d9c96fbdd6486a4aab3b80ab38b5b975712304e9358a5a4fd6473"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f56ce01fbdf94890a9f4eb5fbe2ad579d34e8ef985cf0b230f1d9b7d01828ca"
    sha256 cellar: :any_skip_relocation, ventura:        "73bca56e297aa24ca2f4e6e7a7bd0c7b3c582fcdab852db022fcc1febd3df7bc"
    sha256 cellar: :any_skip_relocation, monterey:       "427eae7b50aff8ea4f4e6c9c2d9a7b58e5f6da8dcb009aaebc4ce76b6bbca56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cddc7fe175e6daea6632828046b77b67fa81b103d998d43b38f3fe1a8d6bdd8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
      -X github.com/simonwhitaker/gibo/cmd.commit=brew
      -X github.com/simonwhitaker/gibo/cmd.date=#{time.iso8601}
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