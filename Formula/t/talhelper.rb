class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.3.11.tar.gz"
  sha256 "c4e2257db0524bf5d3b0dd7ab65fe83612677fb3e06985bdb2f0d4d603f68d6e"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90111dd41ec95fb9d03735f0880d00bee40b0a245e7b1d270b66e0d72c13d9a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fbc4aae9cfd80d0784334511a5588fca5855f19a7877d1358b985d88b6bf5d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4591f96b5a35f66bbcbb18496db4806b5c95fb89c66d8e3f751f4c3bcc5d7be0"
    sha256 cellar: :any_skip_relocation, sonoma:         "40225ff7bb641b6d9bbd818c0b305228b0acd2da06c5a13f6d3e3edcd8b2ea59"
    sha256 cellar: :any_skip_relocation, ventura:        "23178bfce758a5dcc4296f68f76fd28be30148972102160c03cc5d0baa70ff6c"
    sha256 cellar: :any_skip_relocation, monterey:       "a8f04654c0a4103f9efc434f3be005d5a1b6943aba248e85e605a861ebadcc92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe84ce8d5775f8e5294192ae626bfd033c0a0f6a809455bf3223cbb5a12765d4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
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