class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.3.tar.gz"
  sha256 "953e4314a9ce27c83cba8327ab92353d8ae0809f5f56e02f5f2a5ec4daf6aafb"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c1ba6482cce28cadda20ea262e6a4ae493dba3cc19214ce2352b5e3bc5dc81b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0efa1ebd4b3fc3228ea28a8b17b69fb778b8afb68421f60668db3d8ad68a672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a084b39457032f356ad496cefe28eebb605a04b8a2a6e8bdef4fe26e10cafe5"
    sha256 cellar: :any_skip_relocation, sonoma:         "57dfb2396e715b21237296a4bf8265754dce7eebb62cf2da5782343bee18a716"
    sha256 cellar: :any_skip_relocation, ventura:        "cd2a68f9d97e88c5a734c6093d7d1eda3ed6705823e2aa1f19131d1a3520201e"
    sha256 cellar: :any_skip_relocation, monterey:       "5a551bcace742618e48f182753006c14e66a1518403f7fa368afae8a139328d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e854d90bbcb8af6864e96a6e33de2d4e67f730c21d632fc98231889f5e4db18f"
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