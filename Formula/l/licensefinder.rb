class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https:github.compivotalLicenseFinder"
  # pull from git tag as gemspec uses `git ls-files`
  # For versions following v7.1.0, may be able to remove 4cac18e5 patch.
  url "https:github.compivotalLicenseFinder.git",
      tag:      "v7.2.0",
      revision: "461c44c222ea3672d9db70980ff4a272f85da14d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bebfc179cd1d6ee3d51b2fbe20efa02e66f8a5c3c9ac23d2df39adef21e77708"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bebfc179cd1d6ee3d51b2fbe20efa02e66f8a5c3c9ac23d2df39adef21e77708"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bebfc179cd1d6ee3d51b2fbe20efa02e66f8a5c3c9ac23d2df39adef21e77708"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5b8e5c8af9d3a4211bb51bfd02ff1500d1206e065f0ce7843df84e70b3814bd"
    sha256 cellar: :any_skip_relocation, ventura:        "d5b8e5c8af9d3a4211bb51bfd02ff1500d1206e065f0ce7843df84e70b3814bd"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b8e5c8af9d3a4211bb51bfd02ff1500d1206e065f0ce7843df84e70b3814bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "974ad7cbdab774fbec56360c8dfca612d76a2bdda6de7ae0be19c3f2c62af669"
  end

  depends_on "ruby"

  # Ruby 3.3 introduced changes that mean we now need to manually require
  # racc. See https:bugs.ruby-lang.orgissues19702 for details.
  # LicenseFinder versions after v7.1.0 may address this requirement.
  patch do
    url "https:github.compivotalLicenseFindercommit4cac18e5c7a48f72700b8de4db97d3150637a20d.patch?full_index=1"
    sha256 "7a7a9b201cd34a5f868901841ba5f144f0e75580664c8ec024792449348f5875"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "license_finder.gemspec"
    system "gem", "install", "license_finder-#{version}.gem"
    bin.install libexec"binlicense_finder"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["GEM_PATH"] = ENV["GEM_HOME"] = testpath
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin

    (testpath"Gemfile").write <<~EOS
      source 'https:rubygems.org'
      gem 'license_finder', '#{version}'
      gem 'racc'
    EOS

    system "bundle", "install"
    assert_match "license_finder, #{version}, #{license}",
                  shell_output(bin"license_finder", 1)
  end
end