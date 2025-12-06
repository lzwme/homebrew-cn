class Gobo < Formula
  desc "Free and portable Eiffel tools and libraries"
  homepage "https://www.gobosoft.com/"
  url "https://downloads.sourceforge.net/project/gobo-eiffel/gobo-eiffel/25.12/gobo-25.12.tar.gz"
  sha256 "d8db1bd9fffa32b09eca4cfc3748bb8e6e8e0d71a8e12d33acc366bf675493a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ac9c2dda16f06f39269c7e6c9883c50cf1242d4f56fe75408f31dfb7147364b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e350b5800d02ffe3943c9316147acef229397a6be9b6abf7fa94eeba78ecdbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "602bebfce472d39a08225dc9761afe7fa07c06f71ea2e0bc575fedf90190ebb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b672ec137f80cae00aa3430241d552a625a21b209a28167d95d440a6e681c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "501f0101db273078334a7e608a44bc06d89f3e1d76c48992175f616df2b0a7ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c4c3987bcfb0de460d0a3ee00af6fd69ce0b2d0af1dec70db11d91b984aa15"
  end

  depends_on "eiffelstudio" => :test

  def install
    ENV["GOBO"] = buildpath
    ENV.prepend_path "PATH", buildpath/"bin"
    # The value for compiler needs to be an unversioned name, but it will still use
    # the compiler shim which will choose the correct compiler.
    compiler = OS.mac? ? "clang" : "gcc"
    system buildpath/"bin/install.sh", "-v", "--threads=#{ENV.make_jobs}", compiler
    (prefix/"gobo").install Dir[buildpath/"*"]
    (Pathname.glob prefix/"gobo/bin/ge*").each do |p|
      (bin/p.basename).write_env_script p,
                                        "GOBO" => prefix/"gobo",
                                        "PATH" => "#{prefix/"gobo/bin"}:$PATH"
    end
  end

  test do
    (testpath/"build.eant").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <project name="hello" default="help">
        <description>
          system: "Hello World test program"
        </description>
        <inherit>
          <parent location="${GOBO}/library/common/config/eiffel.eant">
            <redefine target="init_system" />
          </parent>
        </inherit>
        <target name="init_system" export="NONE">
          <set name="system" value="hello" />
          <set name="system_dir" value="#{testpath}" />
        </target>
      </project>
    XML
    (testpath/"system.ecf").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <system
          xmlns="http://www.eiffel.com/developers/xml/configuration-1-20-0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-20-0
                              http://www.eiffel.com/developers/xml/configuration-1-20-0.xsd"
          name="hello"
          library_target="all_classes">
        <description>
          system: "Hello World test program"
        </description>
        <target name="all_classes">
          <root all_classes="true" />
          <file_rule>
            <exclude>/EIFGENs$</exclude>
          </file_rule>
          <variable name="GOBO_LIBRARY" value="#{prefix/"gobo"}" />
          <library name="free_elks" location="${GOBO_LIBRARY}/library/free_elks/library_${GOBO_EIFFEL}.ecf" readonly="true" />
          <library name="kernel" location="${GOBO_LIBRARY}/library/kernel/library.ecf" readonly="true"/>
          <cluster name="hello" location="./" />
        </target>
        <target name="hello" extends="all_classes">
          <root class="HELLO" feature="execute" />
          <setting name="console_application" value="true" />
          <capability>
            <concurrency use="none" />
          </capability>
        </target>
      </system>
    XML
    mkdir "src" do
      (testpath/"hello.e").write <<~EOS
        note
          description:
            "Hello World test program"
        class HELLO
        inherit
          KL_SHARED_STANDARD_FILES
        create
          execute
        feature
          execute do
            std.output.put_string ("Hello, world!")
          end
        end
      EOS
    end
    system bin/"geant", "-v", "compile_ge"
    assert_equal "Hello, world!", shell_output(testpath/"hello")
    system bin/"geant", "-v", "clean"
    system bin/"geant", "-v", "compile_ise"
    assert_equal "Hello, world!", shell_output(testpath/"hello")
    system bin/"geant", "-v", "clean"
  end
end