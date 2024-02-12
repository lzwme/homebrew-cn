class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.1.0.tar.gz"
  sha256 "9ae040c6dcd07e2874c0d67cc1fefc104a9812bc4693b1bfb0f1b0501a64da0d"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "231b5617f997369afd0288e4289347b3ecba48b10eba7d9dac4dcdb375179657"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4392608315a904c40098a1056cf2d36e458e793a59e3c926b805371adf3ae789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d9452f29a4ee98bad4dce540bad00928d037eea642f93acb6da9826e877e62"
    sha256 cellar: :any_skip_relocation, sonoma:         "26b94317aa114bc3cb313bf96fde7a05b7d3702320ad2d96b9e42cfaa7955cd9"
    sha256 cellar: :any_skip_relocation, ventura:        "824fcf6ec24010e4500197aa2562a9e6e0433f65b2b6b9d4ca71e2bc28e27261"
    sha256 cellar: :any_skip_relocation, monterey:       "fc279de2b1264c17d28b89efd4e763cfa6c90300518b4fa66b29fd3b59c5f1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca506d567fb3a021ae2ec7d517dfa98658721f65f49d4a22016d01da59e7a0df"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end