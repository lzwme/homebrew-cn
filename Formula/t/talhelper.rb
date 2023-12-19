class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:github.combudimanjojotalhelper"
  url "https:github.combudimanjojotalhelperarchiverefstagsv1.16.3.tar.gz"
  sha256 "7093a54a7bab7378f6b1ae33880ae17423572758d6c20c13410c2811b2e197b0"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b41b466d69766055660ece435087b37e31df241d93ee6e366e51d2c82593f59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc0fb0e4805736d8801154eb182a50863820c849a72b25d7208593d86cae280b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "582c232b4f7b6475f2f49b88377737dfb1e15afe64036f0540440afe7bffcdeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c66cc4466c0b34e6a6ffb35590a567b2cefe6f70262afac43b83daaefa1652ef"
    sha256 cellar: :any_skip_relocation, ventura:        "498008aa97d7c98f926b63cd60b80f04ebc0b2006599919531bf9f0e48045c0a"
    sha256 cellar: :any_skip_relocation, monterey:       "b18638ae73545348f4780124d5869dd146954aa5fac330bf5d797a78187c79b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77283c230f786f3101a07753b516630c2c3af3665fb26402dce8f1333ed84ce8"
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