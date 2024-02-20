class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https:github.comscalewayscaleway-cli"
  url "https:github.comscalewayscaleway-cliarchiverefstagsv2.27.0.tar.gz"
  sha256 "e1488e24730e1f56e14b92a8dc5c05446522c36831e666bb11faf36144547606"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fcc2be12601ed857d1f9c611ed876cfae88505ce5b5ade73d0600ecbb326f0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71dfb7068ae1fbc45dc262bb69f8ca9e53017653deb8b0e532791846ac95e277"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dc326ed23fc240434eeb47f356aa28ebda3c1044f6267bd198e438e661e8c4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "075ec26fdc7df8cd6b709d7dd75ccf41a812ed59d08252a263eacd2ed4f3e6db"
    sha256 cellar: :any_skip_relocation, ventura:        "68e4dc834bd882da995d091f1ac780ccd5f697307f45bb73042d970c0a1523fe"
    sha256 cellar: :any_skip_relocation, monterey:       "f35994417df3ed31b7513cf72dab0335f121cec3adba2acc0003792ffb0a013e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6752f1e57a995a5e4f17aeddf25b6599bd57a84d814016de86dcafab79034be0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), ".cmdscw"

    generate_completions_from_executable(bin"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath"config.yaml").write ""
    output = shell_output(bin"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath"config.yaml")
  end
end