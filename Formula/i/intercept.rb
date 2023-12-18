class Intercept < Formula
  desc "Static Application Security Testing (SAST) tool"
  homepage "https:intercept.cc"
  url "https:github.comxfhginterceptarchiverefstagsv1.5.9.tar.gz"
  sha256 "bc6007b4cfd0cfd81334a20c7f38ba6fa65843a1a92634fb357eff36948d3172"
  license "AGPL-3.0-only"
  head "https:github.comxfhgintercept.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90d89534e7c5a294779b39f3a5798153d413822ede90ee5a76bd821652073e07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c754a07fe89424c07efcde85588bb90bb11e8a5bd871c7199e29b7cf73c6dca8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4373b27045fa20c7d819236ca7165bb77df2e5d8b609188a0cb09c6dc159be6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "96a66a479538c30294c50cf32bc2bbfc6ea12310699c0a676c7343df3a23a7cc"
    sha256 cellar: :any_skip_relocation, ventura:        "d7647ead3b8fd6a1e6387e60823de30b9ab2eeb53018e88ac106d7cca614f2f9"
    sha256 cellar: :any_skip_relocation, monterey:       "d01ba9bbe375ca91345631b077e534d0b0ca42f35a3504b1b1eddbb33928cb28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3636a4420cc899a543b672a008d360850dd9c5bfbdef44006e750ac54a0a8c12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"intercept", "completion")

    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}examples", testpath

    output = shell_output("#{bin}intercept config -r")
    assert_match "Config clear", output

    output = shell_output("#{bin}intercept config -a examplespolicyminimal.yaml")
    assert_match "New Config created", output
  end
end