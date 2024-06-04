class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https:github.comhashicorpconsul-template"
  url "https:github.comhashicorpconsul-templatearchiverefstagsv0.38.0.tar.gz"
  sha256 "f1eb68c603064e1e66e4d2818d35b2a83d5dbbf2702eedf09ecc065bb85769f5"
  license "MPL-2.0"
  head "https:github.comhashicorpconsul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43ab25981a38533964cecc5e145e539666743a7fb8baa87b635e2143461ddb59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6d29153ed8d5b0a8ec3bd23954eb38096792e0613954f9a23bf7c95c348e164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2dd672fba33618e52dd9eaa59cee68e66920c7eada42bc18b73fc6b21f1fb1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "24d2ef4799cc3bf215fdcb3348a42de5b36aeb8d0a05d39c0f4d9eec3ca3625b"
    sha256 cellar: :any_skip_relocation, ventura:        "cb41ec79cdc9d9d9b51252fb6a6d4aa564e858c5e3be429c115db70361ec986c"
    sha256 cellar: :any_skip_relocation, monterey:       "3c0a5e5d09fd3dd34522e6dd9f9924d07ce1575ea8023558123f2e44bbbf7f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76fda718b146bbb886f11f297c5b52ae4fc2835c72b5d1e6f54fb0858fed060"
  end

  depends_on "go" => :build

  def install
    project = "github.comhashicorpconsul-template"
    ldflags = %W[
      -s -w
      -X #{project}version.Name=consul-template
      -X #{project}version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    prefix.install_metafiles
  end

  test do
    (testpath"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath"test-result").read.chomp
  end
end