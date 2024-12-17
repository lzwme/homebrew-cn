class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.12.tar.gz"
  sha256 "81e33059480256100cb9836ce7f77ac9a5eb0a8cd049bb037021e3a8a9f5ce25"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee821ecb79f04dfb98cfcfc7d1e36e1c47163891baa0388834d11858218037c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ee821ecb79f04dfb98cfcfc7d1e36e1c47163891baa0388834d11858218037c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ee821ecb79f04dfb98cfcfc7d1e36e1c47163891baa0388834d11858218037c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d98d568bf1203ce187a7c043e7759189bb32908cc7fad418aee3449ef53c784d"
    sha256 cellar: :any_skip_relocation, ventura:       "d98d568bf1203ce187a7c043e7759189bb32908cc7fad418aee3449ef53c784d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b11bd594920c48fccc501baab5d5d5f481c21550e9ab98e0af722042cd63b64"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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