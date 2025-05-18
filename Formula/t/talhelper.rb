class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.25.tar.gz"
  sha256 "4c7ae4f1f54579498d89f6a11fcb70f96c5837845b39de730dcfeb8d436fa51d"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db1c09b928c7a14e35436482e8257131734f3acee7a336d2e0888836ee4c257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7db1c09b928c7a14e35436482e8257131734f3acee7a336d2e0888836ee4c257"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7db1c09b928c7a14e35436482e8257131734f3acee7a336d2e0888836ee4c257"
    sha256 cellar: :any_skip_relocation, sonoma:        "718aadd2c8262ffed435e5519ff49962a2dd0c4bed2bea41fd827e6fee8b47b9"
    sha256 cellar: :any_skip_relocation, ventura:       "718aadd2c8262ffed435e5519ff49962a2dd0c4bed2bea41fd827e6fee8b47b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd6d14f7adcd3b163ca9bbd3a4950416f95d61be465deb444f81aee08a78f4e"
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