class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https:www.embulk.org"
  url "https:github.comembulkembulkreleasesdownloadv0.11.5embulk-0.11.5.jar"
  sha256 "e2f298db60c2fe1cc17c377edf7215c7005b5d106d151b1a4278a508e4a32e47"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e63d641729a25c7885685cbbbf1152435987f88e63779a37743675030cf567af"
  end

  # From https:www.embulk.org,
  # > Embulk v0.11 officially supports only Java 8, but expected to work somehow with Java 11, 17, and 21.
  #
  # Since `openjdk@8` does not support ARM macOS, we need to use newer version.
  # We keep `openjdk@8` otherwise as upstream claims some plugins may not be compatible.
  # See: https:github.comembulkembulkissues1595#issuecomment-1595677127
  on_arm do
    depends_on "openjdk@21"
  end
  on_intel do
    depends_on "openjdk@8"
  end

  def install
    java_version = Hardware::CPU.intel? ? "1.8" : "21"
    libexec.install "embulk-#{version}.jar"
    bin.write_jar_script libexec"embulk-#{version}.jar", "embulk", java_version:
  end

  test do
    # In order to install a different plugin, we need JRuby, but brew `jruby`
    # seems to hit some failures so using a resource.
    resource "jruby-complete" do
      url "https:search.maven.orgremotecontent?filepath=orgjrubyjruby-complete9.4.8.0jruby-complete-9.4.8.0.jar"
      sha256 "ce537f21a2cfc34cf91fc834d8d1c663c6f3b5bca57cacd45fd4c47ede71c303"
    end
    testpath.install resource("jruby-complete")
    jruby = "jruby=file:#{testpath}jruby-complete-#{resource("jruby-complete").version}.jar"

    (testpath"config.yml").write <<~EOS
      in:
        type: http
        url: https:formulae.brew.shapianalyticsbrew-command-run30d.json
        parser:
          type: json
          root: items
          flatten_json_array: true
          columns:
            - {name: number, type: long}
            - {name: command_run, type: string}
            - {name: count, type: string}
            - {name: percent, type: double}
      out:
        type: stdout
    EOS

    ENV["GEM_HOME"] = testpath"gems"
    system bin"embulk", "-X", jruby, "gem", "install", "embulk", "--version", version.to_s
    system bin"embulk", "-X", jruby, "gem", "install", "embulk-input-http", "msgpack"
    assert_match <<~EOS.chomp, shell_output("#{bin}embulk -X #{jruby} preview config.yml")
      +-------------+-----------------------------+--------------+----------------+
      | number:long |          command_run:string | count:string | percent:double |
      +-------------+-----------------------------+--------------+----------------+
      |           1 |                        list |
    EOS
    assert_match(1,list,.*\n2,install,.*\n3,info,, shell_output("#{bin}embulk -X #{jruby} run config.yml"))

    # Recent macOS requires giving Terminal permissions to access files on a
    # network volume in order to use Embulk's basic file input plugin.
    return if OS.mac? && MacOS.version >= :ventura

    system bin"embulk", "example", ".try1"
    system bin"embulk", "guess", ".try1seed.yml", "-o", "config.yml"
    system bin"embulk", "preview", "config.yml"
    system bin"embulk", "run", "config.yml"
  end
end