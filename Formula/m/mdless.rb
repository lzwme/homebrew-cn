class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https:github.comttscoffmdless"
  url "https:github.comttscoffmdlessarchiverefstags2.1.51.tar.gz"
  sha256 "fedd185416a7c4c88c824f48f13da843d0535f0dded13ead0b6cae7bf174da5d"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c53f9b1eec7442a0c501a5758f98c1efe742d1e75ae2cd7b9de84b0a0ffee6d6"
    sha256 cellar: :any,                 arm64_sonoma:  "b7465de4d8a7ed2734ddb505f188bc3dc7582134f98c94eb46e3fcf70b235039"
    sha256 cellar: :any,                 arm64_ventura: "529b3fde7b425c29020d5a977337af1137da0744f81c455a70b1648728d88972"
    sha256 cellar: :any,                 sonoma:        "315028ea29ae443c4d56b91cbb66e7cc32159fc281d7eb6455b0c00462524783"
    sha256 cellar: :any,                 ventura:       "5abacf54acfca534e3c413c0fa6f93c1543f28c0fa326e1ad38947bd38ba8224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbdf674a68b07d2f6a39ba0c256a29dc2b841505360418884b587d372ee86a47"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  # version patch, upstream pr ref, https:github.comttscoffmdlesspull103
  patch do
    url "https:github.comttscoffmdlesscommit3462d11f8c8dc5936cdae573a6ce9a2837ceaba6.patch?full_index=1"
    sha256 "f8da80dcc221cbf125841aee49da31912b1f3f82208a3fd99c0906e0c930863c"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}mdless --version")
    (testpath"test.md").write <<~MARKDOWN
      # title first level
      ## title second level
    MARKDOWN
    out = shell_output("#{bin}mdless --no-color -P test.md")
    assert_match(^title first level =+$, out)
    assert_match(^title second level -+$, out)
  end
end