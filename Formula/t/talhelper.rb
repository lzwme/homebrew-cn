class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.2.tar.gz"
  sha256 "8a39408770ef3bc943751475677e57f294255d770ee14505df3e60847a3661d7"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55dfa4bb54e4ea400ea7cb11c858303b5b075223e2fcf42c960a85880dff11ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0097d7b58dfafa55b8520ac5d79389c2a6325792a5e53b44dcc2a4892d55d810"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "515c03d8b29e738f98eb2e194a11e55c19b0910eef56e43d58b789e94be6ce23"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1ce782b77c3ddfafb078b85dcb87b3b57e76364be1829ae50e4e8f4f474600e"
    sha256 cellar: :any_skip_relocation, ventura:        "5f04b44aa73df1ab9c9b2cc54157153afd4097b75a2d0fd307fa785abf777cdc"
    sha256 cellar: :any_skip_relocation, monterey:       "4ccdd341cb70f364236a0f13848520a9f4cdd30053df2d50eb38f2d09186d853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91449a88d8955b00680a319f4ee77306f9fcdf201bd30a84dbaa312216f3074e"
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