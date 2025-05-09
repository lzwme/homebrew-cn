class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.24.tar.gz"
  sha256 "39f34dd4a5d94188bacdea85362307217e56eceba92801dd9a534c19fed91fe8"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b9cea08a4644d4b449ce379bc716285e94cd530e8ecbdda4a050ec302dd8de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b9cea08a4644d4b449ce379bc716285e94cd530e8ecbdda4a050ec302dd8de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9b9cea08a4644d4b449ce379bc716285e94cd530e8ecbdda4a050ec302dd8de"
    sha256 cellar: :any_skip_relocation, sonoma:        "56e5e8c9919e86dc80aabbe76b05d1e0f5eb37cd1803494b48d34ed2fc38e64c"
    sha256 cellar: :any_skip_relocation, ventura:       "56e5e8c9919e86dc80aabbe76b05d1e0f5eb37cd1803494b48d34ed2fc38e64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74f1ac69469b0474047c636ac317e314dd5ad4924bc55588622b0fad7f94cda"
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