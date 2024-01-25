class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:github.comreplicatecog"
  url "https:github.comreplicatecogarchiverefstagsv0.9.4.tar.gz"
  sha256 "d3df9a9b9af79f6309f3acf31d6a3363270c0a5a7838ee75d4a02a8ed92fb0ae"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9607d67f1daad0773dbd61bcaa15a1dc11fc665e8c77ae2cccd1b354f1a28dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4520e29a916789738511cf4d3fd95ba781cf186610d842111e5bd830ff61e118"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9847d66f28a3f3a3cb5bb8ef8981770a25be18e101cde018789d3f89efdb6432"
    sha256 cellar: :any_skip_relocation, sonoma:         "cde56c998cb6bc6f737a19d902197dd75b38850d2793f6edff67f7fdbc63f691"
    sha256 cellar: :any_skip_relocation, ventura:        "69d69fc781adde98bb3b7c48f83e2b7e18620b0436ad2654db2e67c2edede835"
    sha256 cellar: :any_skip_relocation, monterey:       "28327f30bd446709b509e5f840e10836d00225da838080e0be81451b1f965489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75dd722d98a48d789bb18a7d010e6dba4fd9d875cae0ccc43a0a6f7b7d03dee"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}cog build 2>&1", 1)
  end
end