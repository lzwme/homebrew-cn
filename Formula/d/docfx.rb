class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https:dotnet.github.iodocfx"
  url "https:github.comdotnetdocfxarchiverefstagsv2.75.1.tar.gz"
  sha256 "e6a6be19be556abce791ba1729cf47e84befa9f13b9134609651b51da9c67107"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c71421a361c63ccc3ec17ad67bf2dac46080347cbe73376ed0e07c5ed96f8dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7b96f46e3f70eae0a6c145a7288a0aa509e60949f5e2f5df14eb02dd951afbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65032440d80e2f37293cc6c17a647037bec3262abca02c5225eb3b7183d392bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "678677adcd77c89cccc1fd2a31f6905e42bceda5d5f2ed68ba4dc4ef1f18fa2e"
    sha256 cellar: :any_skip_relocation, ventura:        "9e318f49be00fc7b22ca1fce83868fab3b8e7d9aa94f4cd44b5a29febf871fbc"
    sha256 cellar: :any_skip_relocation, monterey:       "a49ab86026a572d7ed3d7ed34cb48cd391ba5b87a3e0530062606cae2872c4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45993ce736ab9b0afc19e87ef89b4efbf5b4b550a96226d81736ed9ab28f008"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https:github.comdotnetdocfxblobmainDirectory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    system "dotnet", "publish", "srcdocfx", *args

    (bin"docfx").write_env_script libexec"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin"docfx", "init", "--yes", "--output", testpath"docfx_project"
    assert_predicate testpath"docfx_projectdocfx.json", :exist?,
                     "Failed to generate project"
  end
end